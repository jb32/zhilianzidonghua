package com.jb.Mapper;

import com.jb.model.Device;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;

public interface DeviceMapper {
    int deleteByPrimaryKey(String id);

    int insert(Device record);

    int insertSelective(Device record);

    @Insert("insert into Device (id, ip, port, type) VALUES (#{id}, #{ip}, #{port}, #{type}) on duplicate key update Device.ip=values(ip), Device.port=values(port)")
    void insertOnDuplicate(@Param("id") String id, @Param("ip") String ip, @Param("port") Integer port, @Param("type") Integer type);

    Device selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Device record);

    int updateByPrimaryKey(Device record);
}
