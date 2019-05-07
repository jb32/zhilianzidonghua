package com.jb.Mapper;

import com.jb.model.Handle;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

public interface HandleMapper {
    int deleteByPrimaryKey(Integer id);

    @Select("delete from Handle where userId=#{uid} and deviceId=#{deviceId}")
    int deleteByUserid(Integer uid, String deviceId);

    int insert(Handle record);

    int insertSelective(Handle record);

    Handle selectByPrimaryKey(Integer id);

    @Select("select * from Handle where deviceId=#{mid}")
    Handle[] selectByDeviceId(String mid);

    @Select("select * from Handle where userId=#{uid} and type=0")
    Handle[] selectMidsByUserId(Integer uid);

    @Select("select * from Handle where userId=#{uid} and deviceId=#{mid} limit 1")
    Handle selectMidByUserId(@Param("uid") Integer uid, @Param("mid") String mid);

    @Select("select * from Handle where userId=#{uid} and type=1")
    Handle selectAppByUserId(Integer uid);

    int updateByPrimaryKeySelective(Handle record);

    int updateByPrimaryKey(Handle record);
}
